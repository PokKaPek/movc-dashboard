import React, { useState } from 'react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

export default function Dashboard() {
  const [population, setPopulation] = useState(1000000);
  const [txFeeRate, setTxFeeRate] = useState(0.0001);
  const [dailyDistribution, setDailyDistribution] = useState(4000);

  const generateSimulationData = () => {
    const days = 365;
    let data = [];
    let reserve = 0, distributed = 0;
    for (let day = 0; day <= days; day++) {
      reserve += population * txFeeRate;
      distributed += dailyDistribution;
      data.push({
        day,
        distributed,
        reserve,
        minted: Math.max(0, dailyDistribution - population * txFeeRate),
        burned: Math.random() * 10,
        total: distributed + reserve
      });
    }
    return data;
  };

  const data = generateSimulationData();

  return (
    <div style={{ padding: 20 }}>
      <h2>MOVC Dashboard Simulation</h2>
      <div style={{ display: "flex", gap: 20, marginBottom: 20 }}>
        <div>
          <label>Population: </label>
          <input type="number" value={population} onChange={e => setPopulation(Number(e.target.value))} />
        </div>
        <div>
          <label>Fee Rate: </label>
          <input type="number" step="0.0001" value={txFeeRate} onChange={e => setTxFeeRate(Number(e.target.value))} />
        </div>
        <div>
          <label>Daily Distribution: </label>
          <input type="number" value={dailyDistribution} onChange={e => setDailyDistribution(Number(e.target.value))} />
        </div>
      </div>
      <ResponsiveContainer width="100%" height={400}>
        <LineChart data={data}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis dataKey="day" />
          <YAxis />
          <Tooltip />
          <Legend />
          <Line type="monotone" dataKey="distributed" stroke="#82ca9d" />
          <Line type="monotone" dataKey="reserve" stroke="#8884d8" />
          <Line type="monotone" dataKey="minted" stroke="#ffc658" />
          <Line type="monotone" dataKey="burned" stroke="#ff8042" />
          <Line type="monotone" dataKey="total" stroke="#0088fe" />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}
