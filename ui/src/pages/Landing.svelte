<script lang="ts">
  import { AppConfig, appRoutes } from '../config';
  import { user } from '../stores';
  import { Github, Users, Zap } from '@lucide/svelte';
  import LL from '../i18n/i18n-svelte';
  import Countries from '../components/user/Countries.svelte';
  import BrowserMock from '../components/global/BrowserMock.svelte';
  import { onMount } from 'svelte';
  import type { ApiClient } from '../types/apiclient';

  interface Props {
    xfetch: ApiClient;
  }

  let { xfetch }: Props = $props();

  const { ShowActiveCountries, PathPrefix, RepoURL } = AppConfig;

  const slogans = [
    'Расширьте возможности ваших Agile-команд',
    'Высвободите силу грома в вашем Agile-процессе',
    'Пронеситесь штормом через спринты вашей команды',
    'Наэлектризуйте ваш Agile-опыт',
    'Арена, где Agile-команды достигают совершенства',
    'Возвращаем энергию в Agile',
    'Обуздайте шторм, освойте спринт',
    'Усильте Agile-потенциал вашей команды',
  ];

  let randomSlogan = $derived(slogans[Math.floor(Math.random() * slogans.length)]);

  onMount(() => window.scrollTo(0, 0));
</script>

<svelte:head>
  <title>{$LL.appName()} - {$LL.appSubtitle()}</title>
</svelte:head>

<main class="bg-gray-100 dark:bg-gray-900">
  <header class="bg-gradient-to-r from-blue-600 to-indigo-700 text-white">
    <div class="container mx-auto px-4 py-16">
      <div class="max-w-7xl mx-auto text-center">
        <h1 class="text-4xl sm:text-5xl lg:text-6xl font-bold mb-6 leading-tight">
          <span class="block bg-clip-text text-transparent bg-gradient-to-r from-yellow-thunder to-orange-500">
            Thunderdome
          </span>
          {randomSlogan}
        </h1>
        <p class="max-w-4xl mx-auto text-xl sm:text-2xl text-blue-100 mb-8">
          Превратите ваши agile-церемонии из пустой траты времени в инструменты для построения команды. Получите инструменты, которые действительно работают для удаленных и офисных команд в planning poker, ретроспективах и story mapping.
        </p>
        <div class="flex flex-col sm:flex-row items-center justify-center space-y-4 sm:space-y-0 sm:space-x-6">
          {#if $user.id}
            <a
              href={appRoutes.games}
              class="bg-white text-indigo-700 hover:bg-gray-100 font-semibold py-3 px-8 rounded-full transition duration-300 shadow-lg"
            >
              Начать планирование
            </a>
          {:else}
            <a
              href={appRoutes.register}
              class="bg-white text-indigo-700 hover:bg-gray-100 font-semibold py-3 px-8 rounded-full transition duration-300 shadow-lg"
            >
              Начать бесплатно
            </a>
          {/if}
          <a
            href="#features"
            class="bg-transparent text-white hover:bg-white/10 border border-white font-semibold py-3 px-8 rounded-full transition duration-300"
          >
            Изучить возможности
          </a>
        </div>
      </div>
    </div>
  </header>

  <section id="features" class="bg-white dark:bg-gray-800 py-20">
    <div class="container mx-auto px-4">
      <div class="flex flex-col md:flex-row items-center justify-between">
        <div class="md:w-1/2 md:pe-8 mb-8 md:mb-0">
          <div class="title-line bg-yellow-thunder"></div>
          <h2 class="text-4xl font-semibold font-rajdhani uppercase dark:text-white mb-6">
            Planning Poker, который достигает консенсуса
          </h2>
          <p class="text-lg text-gray-600 dark:text-gray-400 mb-4">
            Перестаньте позволять самому громкому голосу побеждать в ваших оценках. Получайте точные story points от всей команды с помощью беспристрастного голосования.
          </p>
          <ul class="space-y-3 text-gray-700 dark:text-gray-300 mb-8">
            <li class="flex items-start">
              <span class="text-indigo-500 dark:text-indigo-400 me-2">✓</span>
              <span><strong>Устраните предвзятость оценок:</strong> Анонимное голосование предотвращает эффект якоря и групповое мышление</span>
            </li>
            <li class="flex items-start">
              <span class="text-indigo-500 dark:text-indigo-400 me-2">✓</span>
              <span><strong>Гибкие шкалы:</strong> Используйте Фибоначчи, размеры футболок или создайте собственные диапазоны, подходящие вашему рабочему процессу</span>
            </li>
            <li class="flex items-start">
              <span class="text-indigo-500 dark:text-indigo-400 me-2">✓</span>
              <span><strong>Дизайн для удаленной работы:</strong> Равное участие независимо от того, находитесь вы в офисе или работаете распределенно</span>
            </li>
          </ul>
          <a
            href={appRoutes.games}
            class="group relative inline-flex items-center justify-center p-0.5 mb-2 me-2 overflow-hidden font-medium text-gray-900 rounded-lg group bg-gradient-to-br from-purple-600 to-blue-500 group-hover:from-purple-600 group-hover:to-blue-500 hover:text-white dark:text-white focus:ring-4 focus:outline-none focus:ring-blue-300 dark:focus:ring-blue-800"
          >
            <span
              class="relative px-5 py-2.5 transition-all ease-in duration-75 bg-white dark:bg-gray-900 rounded-md group-hover:bg-opacity-0"
            >
              {$user.id ? $LL.battleCreate() : 'Попробовать Planning Poker'}
            </span>
          </a>
        </div>
        <div class="md:w-1/2">
          <BrowserMock>
            <img
              class="rounded-b-lg hidden dark:block"
              src="{PathPrefix}/img/previews/planning_poker_20250812_dark.png"
              alt={$LL.appPreviewAlt()}
            />
            <img
              class="rounded-b-lg dark:hidden"
              src="{PathPrefix}/img/previews/planning_poker_20250812_light.png"
              alt={$LL.appPreviewAlt()}
            />
          </BrowserMock>
        </div>
      </div>
    </div>
  </section>

  <section class="bg-gray-100 dark:bg-gray-900 py-20">
    <div class="container mx-auto px-4">
      <div class="flex flex-col md:flex-row-reverse items-center justify-between">
        <div class="md:w-1/2 md:ps-8 mb-8 md:mb-0">
          <div class="title-line bg-yellow-thunder"></div>
          <h2 class="text-4xl font-semibold font-rajdhani uppercase dark:text-white mb-6">
            Ретроспективы, которые приводят к изменениям
          </h2>
          <p class="text-lg text-gray-600 dark:text-gray-400 mb-4">
            Выйдите за рамки привычных обсуждений "что прошло хорошо". Создайте психологическую безопасность, где происходят реальные улучшения.
          </p>
          <ul class="space-y-3 text-gray-700 dark:text-gray-300 mb-8">
            <li class="flex items-start">
              <span class="text-indigo-500 dark:text-indigo-400 me-2">✓</span>
              <span><strong>Проверенные форматы:</strong> Start/Stop/Continue, 4L, Mad/Sad/Glad, плюс пользовательские шаблоны</span>
            </li>
            <li class="flex items-start">
              <span class="text-indigo-500 dark:text-indigo-400 me-2">✓</span>
              <span><strong>Безопасное пространство для честности:</strong> Анонимная обратная связь устраняет страх осуждения или возмездия</span>
            </li>
            <li class="flex items-start">
              <span class="text-indigo-500 dark:text-indigo-400 me-2">✓</span>
              <span><strong>Работающая подотчетность:</strong> Превращайте инсайты в отслеживаемые пункты действий с последующим контролем</span>
            </li>
          </ul>
          <a
            href={appRoutes.retros}
            class="group relative inline-flex items-center justify-center p-0.5 mb-2 me-2 overflow-hidden font-medium text-gray-900 rounded-lg group bg-gradient-to-br from-purple-600 to-blue-500 group-hover:from-purple-600 group-hover:to-blue-500 hover:text-white dark:text-white focus:ring-4 focus:outline-none focus:ring-blue-300 dark:focus:ring-blue-800"
          >
            <span
              class="relative px-5 py-2.5 transition-all ease-in duration-75 bg-white dark:bg-gray-900 rounded-md group-hover:bg-opacity-0"
            >
              {$user.id ? 'Начать ретроспективу' : 'Попробовать ретроспективы'}
            </span>
          </a>
        </div>
        <div class="md:w-1/2">
          <BrowserMock>
            <img
              class="rounded-b-lg hidden dark:block"
              src="{PathPrefix}/img/previews/retro_20250812_dark.png"
              alt="Превью спринт-ретроспектив"
            />
            <img
              class="rounded-b-lg dark:hidden"
              src="{PathPrefix}/img/previews/retro_20250812_light.png"
              alt="Превью спринт-ретроспектив"
            />
          </BrowserMock>
        </div>
      </div>
    </div>
  </section>

  <section class="bg-white dark:bg-gray-800 py-20">
    <div class="container mx-auto px-4">
      <div class="flex flex-col md:flex-row items-center justify-between">
        <div class="md:w-1/2 md:pe-8 mb-8 md:mb-0">
          <div class="title-line bg-yellow-thunder"></div>
          <h2 class="text-4xl font-semibold font-rajdhani uppercase dark:text-white mb-6">
            Story Maps, которые рассказывают настоящую историю
          </h2>
          <p class="text-lg text-gray-600 dark:text-gray-400 mb-4">
            Перестаньте создавать функции изолированно. Визуализируйте полный путь пользователя и расставляйте приоритеты в том, что действительно важно для ваших пользователей.
          </p>
          <ul class="space-y-3 text-gray-700 dark:text-gray-300 mb-8">
            <li class="flex items-start">
              <span class="text-indigo-500 dark:text-indigo-400 me-2">✓</span>
              <span><strong>Интуитивное перетаскивание:</strong> Реорганизуйте истории так же легко, как перемещаете стикеры по карте.</span>
            </li>
            <li class="flex items-start">
              <span class="text-indigo-500 dark:text-indigo-400 me-2">✓</span>
              <span><strong>Гибкая организация историй:</strong> Структурируйте работу с помощью целей, столбцов, персон и визуальных подсказок, которые подходят рабочему процессу вашей команды.</span>
            </li>
            <li class="flex items-start">
              <span class="text-indigo-500 dark:text-indigo-400 me-2">✓</span>
              <span><strong>Подробные детали историй:</strong> Храните описания, критерии приемки и оценки вместе, где вся команда может их видеть.</span>
            </li>
          </ul>
          <a
            href={appRoutes.storyboards}
            class="group relative inline-flex items-center justify-center p-0.5 mb-2 me-2 overflow-hidden font-medium text-gray-900 rounded-lg group bg-gradient-to-br from-purple-600 to-blue-500 group-hover:from-purple-600 group-hover:to-blue-500 hover:text-white dark:text-white focus:ring-4 focus:outline-none focus:ring-blue-300 dark:focus:ring-blue-800"
          >
            <span
              class="relative px-5 py-2.5 transition-all ease-in duration-75 bg-white dark:bg-gray-900 rounded-md group-hover:bg-opacity-0"
            >
              {$user.id ? 'Создать Story Map' : 'Попробовать Story Mapping'}
            </span>
          </a>
        </div>
        <div class="md:w-1/2">
          <BrowserMock>
            <img
              class="rounded-b-lg hidden dark:block"
              src="{PathPrefix}/img/previews/storyboard_20250812_dark.png"
              alt="Превью Story Mapping"
            />
            <img
              class="rounded-b-lg dark:hidden"
              src="{PathPrefix}/img/previews/storyboard_20250812_light.png"
              alt="Превью Story Mapping"
            />
          </BrowserMock>
        </div>
      </div>
    </div>
  </section>

  <section class="bg-gray-100 dark:bg-gray-900 py-20">
    <div class="container mx-auto px-4">
      <div class="flex flex-col md:flex-row-reverse items-center justify-between">
        <div class="md:w-1/2 md:ps-8 mb-8 md:mb-0">
          <div class="title-line bg-yellow-thunder"></div>
          <h2 class="text-4xl font-semibold font-rajdhani uppercase dark:text-white mb-6">Командные отметки</h2>
          <p class="text-lg text-gray-600 dark:text-gray-400 mb-8">
            Пропустите обновления статуса, которые все уже знают. Сосредоточьте ваши ежедневные стендапы на блокерах, зависимостях и том, что действительно требует обсуждения команды.
          </p>
          <ul class="space-y-3 text-gray-700 dark:text-gray-300 mb-8">
            <li class="flex items-start">
              <span class="text-indigo-500 dark:text-indigo-400 me-2">✓</span>
              <span><strong>Синхронизация команды в реальном времени:</strong> Живая совместная работа поддерживает синхронизацию распределенных продуктовых команд</span>
            </li>
            <li class="flex items-start">
              <span class="text-indigo-500 dark:text-indigo-400 me-2">✓</span>
              <span><strong>Быстрое выявление блокеров:</strong> Выделяйте блокеры и темы для обсуждения, чтобы команда могла сосредоточиться на том, что действительно требует внимания</span>
            </li>
            <li class="flex items-start">
              <span class="text-indigo-500 dark:text-indigo-400 me-2">✓</span>
              <span><strong>Комментируйте отметки напрямую:</strong> Члены команды могут добавлять контекст, вопросы и заметки для последующих действий, не сбивая стендап с курса</span>
            </li>
          </ul>
        </div>
        <div class="md:w-1/2">
          <img
            class="rounded-lg shadow-lg hidden dark:block max-w-lg mx-auto"
            src="{PathPrefix}/img/previews/team_checkins_dark_2025_09_24.png"
            alt="Превью командных отметок"
          />
          <img
            class="rounded-lg shadow-lg dark:hidden max-w-lg mx-auto"
            src="{PathPrefix}/img/previews/team_checkins_light_2025_09_24.png"
            alt="Превью командных отметок"
          />
        </div>
      </div>
    </div>
  </section>

  <section class="bg-indigo-600 text-white py-20">
    <div class="container mx-auto px-4 text-center">
      <h2 class="text-4xl font-bold mb-6 font-rajdhani uppercase">Почему выбрать Thunderdome?</h2>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
        <div class="bg-white dark:bg-gray-800 rounded-lg p-6 text-gray-800 dark:text-white">
          <div class="text-indigo-500 text-4xl mb-4">
            <Zap class="h-12 w-12 mx-auto" />
          </div>
          <h3 class="text-xl font-semibold mb-2">Создан для удаленных команд</h3>
          <p>
            Каждая функция работает безупречно независимо от того, находится ли ваша команда в одной комнате или разбросана по континентам. Никаких компромиссов "дружественных к удаленной работе".
          </p>
        </div>
        <div class="bg-white dark:bg-gray-800 rounded-lg p-6 text-gray-800 dark:text-white">
          <div class="text-indigo-500 text-4xl mb-4">
            <Users class="h-12 w-12 mx-auto" />
          </div>
          <h3 class="text-xl font-semibold mb-2">Психологическая безопасность прежде всего</h3>
          <p>
            Анонимные опции, инклюзивная фасилитация и инструменты снижения предвзятости помогают каждому члену команды вносить свои лучшие идеи.
          </p>
        </div>
        <div class="bg-white dark:bg-gray-800 rounded-lg p-6 text-gray-800 dark:text-white">
          <div class="text-indigo-500 text-4xl mb-4">
            <Github class="h-12 w-12 mx-auto" />
          </div>
          <h3 class="text-xl font-semibold mb-2">Открытый исходный код</h3>
          <p>
            <a
              href={appRoutes.subscriptionPricing}
              class="text-indigo-400 dark:text-indigo-300 hover:text-yellow-thunder dark:hover:text-yellow-thunder font-bold"
              >Премиум облачный хостинг</a
            >
            для удобства или
            <a
              href="{RepoURL}/blob/main/docs/INSTALLATION.md"
              target="_blank"
              class="text-indigo-400 dark:text-indigo-300 hover:text-yellow-thunder dark:hover:text-yellow-thunder font-bold"
              >самостоятельный хостинг</a
            > для суверенитета. Выбор полностью за вами.
          </p>
        </div>
      </div>
    </div>
  </section>

  {#if ShowActiveCountries}
    <section class="bg-slate-100 dark:bg-gray-900 py-20">
      <div class="container mx-auto px-4">
        <Countries {xfetch} />
      </div>
    </section>
  {/if}
</main>
