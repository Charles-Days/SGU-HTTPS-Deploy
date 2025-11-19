const API_HOST = import.meta.env.VITE_API_HOST
const API_PORT = import.meta.env.VITE_API_PORT
const API_BASE = import.meta.env.VITE_API_BASE
const API_PROTOCOL = import.meta.env.VITE_API_PROTOCOL || 'https'

const API_URL = `${API_PROTOCOL}://${API_HOST}:${API_PORT}${API_BASE}`

export const getUsers = async () => {
  try {
    const response = await fetch(`${API_URL}/users`)
    const data = await response.json()
    return data
  } catch (error) {
    console.error('Error obteniendo usuarios:', error)
    throw error
  }
}

export const createUser = async (user) => {
  try {
    const response = await fetch(`${API_URL}/users`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(user),
    })
    const data = await response.json()
    return data
  } catch (error) {
    console.error('Error creando usuario:', error)
    throw error
  }
}

export const updateUser = async (id, user) => {
  try {
    const response = await fetch(`${API_URL}/users/${id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(user),
    })
    const data = await response.json()
    return data
  } catch (error) {
    console.error('Error actualizando usuario:', error)
    throw error
  }
}

export const deleteUser = async (id) => {
  try {
    const response = await fetch(`${API_URL}/users/${id}`, {
      method: 'DELETE',
    })
    return response.ok
  } catch (error) {
    console.error('Error eliminando usuario:', error)
    throw error
  }
}
