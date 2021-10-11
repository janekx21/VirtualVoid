import {ActionContext, createStore, Store, useStore as baseUseStore} from "vuex";
import client from "./client";
import gql from "graphql-tag";

import {InjectionKey} from 'vue'
import {Project} from "./model/generated";

// define your typings for the store state
export interface State {
    projects: Project[]
}

// define injection key
export const key: InjectionKey<Store<State>> = Symbol()

export const store = createStore<State>({
    state: {
        projects: []
    },
    getters: {
        projects: (state): ReadonlyArray<Project> => state.projects
    },
    mutations: {
        setProjects: (state, payload: Project[]) => state.projects = payload
    },
    actions: {
        async fetchProjects({commit}: ActionContext<any, any>) {
            const response = await client.query({
                query: gql`
                    query {
                        projects {
                            name
                            short
                            id
                        }
                    }
                `
            });

            commit('setProjects', response.data.projects as Project[])
        }
    }
})

// define your own `useStore` composition function
export function useStore() {
    return baseUseStore(key)
}

