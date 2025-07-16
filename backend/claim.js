
// Example Express-style API (Node.js)
module.exports = async (req, res) => {
  const { userAddress, rewardAmount } = req.body;
  if (!userAddress || !rewardAmount) {
    return res.status(400).json({ error: "Missing userAddress or rewardAmount" });
  }
  // Example: verify off-chain signature here
  return res.status(200).json({
    success: true,
    address: userAddress,
    reward: rewardAmount,
    txHash: "0xtestexample"
  });
};
