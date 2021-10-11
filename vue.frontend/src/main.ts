import {createApp} from 'vue'
import App from './App.vue'
import 'carbon-components/css/carbon-components.css';
import './index.scss'
import Vuex from 'vuex';
import {key, store} from "./store";

createApp(App)
    // .use(CarbonComponentsVue)
    .use(store, key)
    .mount('#app')

