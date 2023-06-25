import React from 'react'
import { IDKitWidget } from '@worldcoin/idkit'

function Home() {
    return (
        <div>
            <IDKitWidget
                app_id="app_staging_098f87ae096baeb76fc81cf587159e87"
                action="my_action"
                enableTelemetry
                onSuccess={result => console.log(result)} // pass the proof to the API or your smart contract
            >
                <div className='flex flex-col'>
                    <p>Hello</p>
                    
                </div>
            </IDKitWidget>
        </div>
    )
}

export default Home