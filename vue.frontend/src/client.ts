// src/utils/graphql.js
import {ApolloClient} from 'apollo-client';
import {HttpLink} from 'apollo-link-http';
import {InMemoryCache} from 'apollo-cache-inmemory';

const enchancedFetch = (url: RequestInfo, init: RequestInit) => {
    // const token = getToken()
    return fetch(url, {
        ...init,
        headers: {
            ...init.headers,
            'Access-Control-Allow-Origin': '*',
            // ...(token && {authorization: `Bearer ${token}`}),
        },
    }).then(response => response)
}


export default new ApolloClient({
    // Provide the URL to the API server.
    link: new HttpLink({
        uri: 'http://localhost:8080/graphql',
    }),
    // Using a cache for blazingly
    // fast subsequent queries.
    cache: new InMemoryCache(),
});
