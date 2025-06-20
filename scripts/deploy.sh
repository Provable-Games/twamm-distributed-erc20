# Check if required environment variables are set
required_vars=("STARKNET_NETWORK" "STARKNET_ACCOUNT" "STARKNET_KEYSTORE")
missing_vars=()

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        missing_vars+=("$var")
    fi
done

if [ ${#missing_vars[@]} -ne 0 ]; then
    echo "Error: The following required environment variables are not set:"
    for var in "${missing_vars[@]}"; do
        echo "  - $var"
    done
    echo "Please set these variables before running the script."
    exit 1
fi

# erc2 config
name="0 0x68656c6c6f 5"
symbol="0 0x68656c6c6f 5"
total_supply=100000000000000000000000

# pool config
pool_fee=3402823669209384634633746074317682114
tick_spacing=354892

# lords
payment_token="0x0124aeb495b947201f5fac96fd1138e326ad86195b98df6dec9009158a533b49"

# savâge
reward_address="0x004878d1148318a31829523ee9c6a5ee563af6cd87f90a30809e5b0d27db8a9b"

# ekubo contracts
core_address="0x00000005dd3D2F4429AF886cD1a3b08289DBcEa99A294197E9eB43b0e0325b4b"
positions_address="0x02e0af29598b407c8716b17f6d2795eca1b471413fa03fb145a5e33722184067"
extensions_address="0x043e4f09c32d13d43a880e85f69f7de93ceda62d6cf2581a582c6db635548fdc"
registry_address="0x0013e25867b6eef62703735aa4cfa7754e72f4e94a56c9d3d9ad8ebe86cee4aa"

scarb build
class_hash=$(starkli declare --watch /workspaces/gerc20/target/dev/gerc20_EkuboDistributedERC20.contract_class.json --compiler-version 2.7.1 2>/dev/null)

starkli deploy $class_hash $name $symbol $total_supply $pool_fee $tick_spacing $payment_token $reward_address $core_address $positions_address $extensions_address $registry_address
