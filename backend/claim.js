// Placeholder for signature claim backend
module.exports = (req, res) => {
  const { userAddress, rewardAmount } = req.body;
  res.status(200).json({
    success: true,
    address: userAddress,
    amount: rewardAmount,
    timestamp: Date.now()
  });
};