from dapr.clients import DaprClient

with DaprClient() as d:
    print('Get state:')
    state_response = d.get_state(store_name="statestore", key="hello")
    data = state_response.data
    print(data)

    print('Get secret:')
    secret_response = d.get_secret(store_name="my-secret-store", key="my-secret")
    data = secret_response
    breakpoint()
    print(data)
