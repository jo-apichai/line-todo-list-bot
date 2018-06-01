import 'whatwg-fetch'

const baseApiPath = '/api/v1'

export const restRequest = async function (path, request = {}) {
  const defaultRequest = {
    headers: {
      'Content-Type': 'application/json'
    },
    credentials: 'same-origin'
  }

  const response = await fetch(
    `${baseApiPath}${path}`,
    Object.assign({}, defaultRequest, request)
  )
  const json = await response.json()

  return json
}