# Blockchain-Based Cleaning Services Supply Chain Management

A comprehensive blockchain solution for managing cleaning services supply chain operations using Clarity smart contracts on the Stacks blockchain.

## Overview

This system provides end-to-end supply chain management for cleaning services, including supplier verification, inventory tracking, order management, quality assurance, and cost optimization.

## Smart Contracts

### 1. Supplier Verification Contract (`supplier-verification.clar`)
- **Purpose**: Validates and manages cleaning supply suppliers
- **Key Features**:
    - Supplier registration and verification
    - Certification management
    - Verification scoring system
    - Owner-controlled verification process

### 2. Inventory Tracking Contract (`inventory-tracking.clar`)
- **Purpose**: Tracks cleaning supply inventory across the supply chain
- **Key Features**:
    - Real-time inventory management
    - Item movement tracking
    - Location-based inventory
    - Stock level monitoring

### 3. Order Management Contract (`order-management.clar`)
- **Purpose**: Manages cleaning supply orders throughout the supply chain
- **Key Features**:
    - Order creation and tracking
    - Multi-item order support
    - Status management
    - Payment processing

### 4. Quality Assurance Contract (`quality-assurance.clar`)
- **Purpose**: Ensures cleaning supply quality through testing and certification
- **Key Features**:
    - Quality testing records
    - Certification management
    - Quality standards definition
    - Compliance tracking

### 5. Cost Optimization Contract (`cost-optimization.clar`)
- **Purpose**: Optimizes cleaning supply costs through pricing analysis
- **Key Features**:
    - Pricing tier management
    - Bulk discount calculations
    - Cost analysis and recommendations
    - Savings tracking

## Contract Functions

### Supplier Verification
\`\`\`clarity
(register-supplier name address)
(verify-supplier supplier-id score)
(add-certification supplier-id cert-type expiry-date issuer)
(get-supplier supplier-id)
(is-supplier-verified supplier-id)
\`\`\`

### Inventory Tracking
\`\`\`clarity
(add-inventory-item name category supplier-id quantity unit-price location)
(update-inventory item-id new-quantity)
(record-movement item-id from-location to-location quantity movement-type)
(get-inventory-item item-id)
(get-stock-level item-id)
\`\`\`

### Order Management
\`\`\`clarity
(create-order supplier-id total-amount)
(add-order-item order-id item-index item-id quantity unit-price)
(update-order-status order-id new-status)
(process-payment order-id)
(get-order order-id)
\`\`\`

### Quality Assurance
\`\`\`clarity
(create-quality-standard name category min-score test-frequency)
(record-quality-test item-id test-type result score notes)
(issue-certification item-id standard-id expiry-date)
(get-quality-test test-id)
(is-item-quality-valid item-id min-score)
\`\`\`

### Cost Optimization
\`\`\`clarity
(create-pricing-tier supplier-id item-category min-quantity max-quantity discount-percentage base-price)
(calculate-optimized-cost item-id supplier-id quantity base-cost)
(add-bulk-discount supplier-id min-order-value discount-rate valid-until)
(get-bulk-discount-rate supplier-id order-value)
\`\`\`

## Data Structures

### Supplier Data
- Supplier ID, name, address
- Verification status and score
- Registration date
- Certifications with expiry dates

### Inventory Data
- Item details (name, category, supplier)
- Quantity and pricing information
- Location tracking
- Movement history

### Order Data
- Customer and supplier information
- Order items with quantities and prices
- Status tracking (pending, confirmed, delivered)
- Payment status

### Quality Data
- Test results and scores
- Quality standards and requirements
- Certification records
- Compliance status

### Cost Data
- Pricing tiers and discounts
- Cost analysis and savings
- Bulk discount rates
- Optimization recommendations

## Usage Examples

### 1. Register a New Supplier
\`\`\`clarity
(contract-call? .supplier-verification register-supplier "CleanCorp Inc" "123 Supply St, City")
\`\`\`

### 2. Add Inventory Item
\`\`\`clarity
(contract-call? .inventory-tracking add-inventory-item
"All-Purpose Cleaner"
"Cleaning Solutions"
u1
u100
u1500
"Warehouse A")
\`\`\`

### 3. Create Order
\`\`\`clarity
(contract-call? .order-management create-order u1 u15000)
\`\`\`

### 4. Record Quality Test
\`\`\`clarity
(contract-call? .quality-assurance record-quality-test
u1
"Chemical Analysis"
"Pass"
u95
"Meets all safety standards")
\`\`\`

### 5. Calculate Optimized Cost
\`\`\`clarity
(contract-call? .cost-optimization calculate-optimized-cost u1 u1 u50 u7500)
\`\`\`

## Security Features

- **Access Control**: Owner-only functions for critical operations
- **Data Validation**: Input validation and error handling
- **Immutable Records**: Blockchain-based audit trail
- **Transparent Operations**: All transactions are publicly verifiable

## Benefits

1. **Transparency**: Complete visibility into supply chain operations
2. **Traceability**: Track items from supplier to end customer
3. **Quality Assurance**: Automated quality control and compliance
4. **Cost Efficiency**: Optimized pricing and bulk discount management
5. **Trust**: Verified suppliers and immutable transaction records

## Getting Started

1. Deploy the smart contracts to the Stacks blockchain
2. Register suppliers using the supplier verification contract
3. Add inventory items and set up quality standards
4. Create orders and track them through the system
5. Monitor costs and optimize pricing strategies

## Testing

Run the test suite using Vitest:

\`\`\`bash
npm test
\`\`\`

## Contributing

Please read the PR details file for contribution guidelines and development workflow.

## License

This project is licensed under the MIT License.
