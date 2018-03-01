const serverAddress = 'http://$PUBLIC_IP_ADDRESS:9000'

function turnOn() {
  fetch(serverAddress + '/on')
}

function turnOff() {
  fetch(serverAddress + '/off')
}

const Page = ({ stars }) =>
  <div>
    <button onClick={turnOn}>Upali</button>
    <br />
    <button onClick={turnOff}>Ugasi</button>
    Next stars: {stars}
  </div>

Page.getInitialProps = async ({ req }) => {
  return { stars: 8 }
}

export default Page
