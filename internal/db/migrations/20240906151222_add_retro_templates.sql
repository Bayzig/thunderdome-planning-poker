-- +goose Up
-- +goose StatementBegin

-- Create a new table for retro templates
CREATE TABLE thunderdome.retro_template (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(32) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    format JSONB NOT NULL,
    is_public BOOLEAN NOT NULL DEFAULT false,
    created_by UUID REFERENCES thunderdome.users(id) ON DELETE CASCADE,
    organization_id UUID REFERENCES thunderdome.organization(id) ON DELETE CASCADE ,
    team_id UUID REFERENCES thunderdome.team(id) ON DELETE CASCADE ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_ownership CHECK (
        (is_public = true AND organization_id IS NULL AND team_id IS NULL) OR
        (is_public = false AND (organization_id IS NOT NULL OR team_id IS NOT NULL))
    )
);

-- Add indexes for better query performance
CREATE INDEX idx_retro_template_organization ON thunderdome.retro_template(organization_id);
CREATE INDEX idx_retro_template_team ON thunderdome.retro_template(team_id);
CREATE INDEX idx_retro_template_public ON thunderdome.retro_template(is_public);

-- Insert pre-defined templates
INSERT INTO thunderdome.retro_template (id, name, code, description, format, is_public)
VALUES
(
    '5c3b4783-82cb-45a4-ac7b-c956c6b4047e', -- hardcoded UUID for the default template
    'Хорошо/Требует улучшения/Вопросы',
    'worked_improve_question',
    'Подумайте о том, что прошло хорошо, что требует улучшения и какие вопросы у вас возникли',
    '{"columns": [
                {"name": "worked", "label": "Что сработало", "color": "green", "icon": "smiley"},
                {"name": "improve", "label": "Что требует улучшения", "color": "red", "icon": "frown"},
                {"name": "question", "label": "Я хочу спросить", "color": "blue", "icon": "question"}
        ]}',
    true
),
(
    gen_random_uuid(),
    'Начать/Прекратить/Продолжить',
    'start_stop_continue',
    'Обдумайте, что начать делать, что прекратить и что продолжить',
    '{"columns": [
            {"name": "start", "label": "Начать", "color": "green"},
            {"name": "stop", "label": "Прекратить", "color": "red"},
            {"name": "continue", "label": "Продолжить", "color": "blue"}
    ]}',
    true
),
(
    gen_random_uuid(),
    'Злит/Огорчает/Радует',
    'mad_sad_glad',
    'Выразите свои чувства о спринте: что вас разозлило, огорчило или обрадовало',
    '{"columns": [
                {"name": "mad", "label": "Злит", "color": "red", "icon": "angry"},
                {"name": "sad", "label": "Огорчает", "color": "blue", "icon": "frown"},
                {"name": "glad", "label": "Радует", "color": "green", "icon": "smiley"}
        ]}',
    true
),
(
    gen_random_uuid(),
    'Отбросить/Добавить/Сохранить/Улучшить',
    'drop_add_keep_improve',
    'Подумайте, что отбросить, добавить, сохранить и улучшить в следующем спринте',
    '{"columns": [
            {"name": "drop", "label": "Отбросить", "color": "red"},
             {"name": "add", "label": "Добавить", "color": "green"},
            {"name": "keep", "label": "Сохранить", "color": "blue"},
            {"name": "improve", "label": "Улучшить", "color": "yellow"}
    ]}',
    true
),
(
    gen_random_uuid(),
    'Понравилось/Узнал/Не хватило/Хотелось',
    'liked_learned_lacked_longed_for',
    'Подумайте о том, что понравилось, что узнали, чего не хватило и чего хотелось',
    '{"columns": [
            {"name": "liked", "label": "Понравилось", "color": "green"},
             {"name": "learned", "label": "Узнал", "color": "blue"},
            {"name": "lacked", "label": "Не хватило", "color": "red"},
            {"name": "longedfor", "label": "Хотелось", "color": "yellow"}
    ]}',
    true
);

-- Add a column to the retro table to reference the template used
ALTER TABLE thunderdome.retro
ADD COLUMN template_id UUID REFERENCES thunderdome.retro_template(id) DEFAULT '5c3b4783-82cb-45a4-ac7b-c956c6b4047e';

-- First, drop the existing function
DROP FUNCTION IF EXISTS thunderdome.retro_create(uuid, character varying, character varying, text, text, smallint, character varying, integer, boolean, uuid);

-- Then, create the updated function with the new templateID parameter
CREATE OR REPLACE FUNCTION thunderdome.retro_create(
    userid uuid,
    retroname character varying,
    joincode text,
    facilitatorcode text,
    maxvotes smallint,
    brainstormvisibility character varying,
    phasetimelimitmin integer,
    phaseautoadvance boolean,
    teamid uuid,
    templateid uuid
)
RETURNS uuid
LANGUAGE plpgsql
AS $function$
DECLARE retroId UUID;
BEGIN
    INSERT INTO thunderdome.retro (
        owner_id, name, join_code, facilitator_code,
        max_votes, brainstorm_visibility, phase_time_limit_min, phase_auto_advance,
        team_id, template_id
    )
    VALUES (
        userId, retroName, joinCode, facilitatorCode,
        maxVotes, brainstormVisibility, phasetimelimitmin, phaseautoadvance, teamid, templateid
    ) RETURNING id INTO retroId;

    INSERT INTO thunderdome.retro_facilitator (retro_id, user_id) VALUES (retroId, userId);
    INSERT INTO thunderdome.retro_user (retro_id, user_id) VALUES (retroId, userId);

    RETURN retroId;
END;
$function$;

ALTER TABLE thunderdome.retro DROP COLUMN format;

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin

ALTER TABLE thunderdome.retro ADD COLUMN format VARCHAR(32) DEFAULT 'worked_improve_question' NOT NULL;

DROP FUNCTION IF EXISTS thunderdome.retro_create(uuid, character varying, text, text, smallint, character varying, integer, boolean, uuid, uuid);

CREATE OR REPLACE FUNCTION thunderdome.retro_create(
    userid uuid,
    retroname character varying,
    fmt character varying,
    joincode text,
    facilitatorcode text,
    maxvotes smallint,
    brainstormvisibility character varying,
    phasetimelimitmin integer,
    phaseautoadvance boolean,
    teamid uuid
)
RETURNS uuid
LANGUAGE plpgsql
AS $function$
DECLARE retroId UUID;
BEGIN
    INSERT INTO thunderdome.retro (
        owner_id, name, format, join_code, facilitator_code,
        max_votes, brainstorm_visibility, phase_time_limit_min, phase_auto_advance,
        team_id
    )
    VALUES (
        userId, retroName, fmt, joinCode, facilitatorCode,
        maxVotes, brainstormVisibility, phasetimelimitmin, phaseautoadvance, teamid
    ) RETURNING id INTO retroId;

    INSERT INTO thunderdome.retro_facilitator (retro_id, user_id) VALUES (retroId, userId);
    INSERT INTO thunderdome.retro_user (retro_id, user_id) VALUES (retroId, userId);

    RETURN retroId;
END;
$function$;

-- Remove the template_id column from the retro table
ALTER TABLE thunderdome.retro
DROP COLUMN IF EXISTS template_id;

-- Drop the retro_template table
DROP TABLE IF EXISTS thunderdome.retro_template;

-- +goose StatementEnd
