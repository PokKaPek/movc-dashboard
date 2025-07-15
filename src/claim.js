import React, { useState } from 'react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

export default function Dashboard() {
  const [population, setPopulation] = useState(1000000);
  const [txFeeRate, setTxFeeRate] = useState(0.0001);
  const [dailyDistribution, setDailyDistribution] = useState(4000);

  const generateSimulationData = () => {
    const days = 365;
    let data = [];
    for (let day = 0; day <= days; day++) {
      data.push({
        day,
        distributed: dailyDistribution * day,
        reserve: population * txFeeRate * day,
        minted: Math.max(0, (dailyDistribution - population * txFeeRate) * day),
        burned: Math.random() * 10,
        total: dailyDistribution * day
      });
    }
    return data;
  };

  const data = generateSimulationData();

  return (
    <div style={{ padding: 20 }}>
      <h2>MOVC Dashboard Simulation</h2>
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