/*
    This is our http api, which we use to send requests to
    our back-end API. Note we`re using the Axios library
    for doing this, which is an easy to use AJAX-based
    library. We could (and maybe should) use Fetch, which
    is a native (to browsers) standard, but Axios is easier
    to use when sending JSON back and forth and it`s a Promise-
    based API which helps a lot with asynchronous communication.
    
    @author McKilla Gorilla
*/

import axios from 'axios'
axios.defaults.withCredentials = true;
const api = axios.create({
    baseURL: 'http://localhost:4000/api',
})

// THESE ARE ALL THE REQUESTS WE`LL BE MAKING, ALL REQUESTS HAVE A
// REQUEST METHOD (like get) AND PATH (like /top5list). SOME ALSO
// REQUIRE AN id SO THAT THE SERVER KNOWS ON WHICH LIST TO DO ITS
// WORK, AND SOME REQUIRE DATA, WHICH WE WE WILL FORMAT HERE, FOR WHEN
// WE NEED TO PUT THINGS INTO THE DATABASE OR IF WE HAVE SOME
// CUSTOM FILTERS FOR QUERIES
export const createTop5List = (newListName, newItems, userEmail) => {
    return api.post(`/top5list/`, {
        // SPECIFY THE PAYLOAD
        name: newListName,
        items: newItems,
        ownerEmail: userEmail
    })
}
export const deleteTop5ListById = (id) => api.delete(`/top5list/${id}`)
export const getTop5ListById = (id) => api.get(`/top5list/${id}`)
export const getTop5ListPairs = () => api.get(`/top5listpairs/`)
export const updateTop5ListById = (id, top5List) => {
    return api.put(`/top5list/${id}`, {
        // SPECIFY THE PAYLOAD
        top5List : top5List
    })
}

const apis = {
    createTop5List,
    deleteTop5ListById,
    getTop5ListById,
    getTop5ListPairs,
    updateTop5ListById
}

export default apis
