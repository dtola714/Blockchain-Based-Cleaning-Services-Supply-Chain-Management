;; Order Management Contract
;; Manages cleaning supply orders throughout the supply chain

(define-map orders
  { order-id: uint }
  {
    customer: principal,
    supplier-id: uint,
    total-amount: uint,
    status: (string-ascii 20),
    created-date: uint,
    delivery-date: (optional uint),
    payment-status: (string-ascii 20)
  }
)

(define-map order-items
  { order-id: uint, item-index: uint }
  {
    item-id: uint,
    quantity: uint,
    unit-price: uint,
    subtotal: uint
  }
)

(define-data-var next-order-id uint u1)
(define-data-var contract-owner principal tx-sender)

;; Create new order
(define-public (create-order (supplier-id uint) (total-amount uint))
  (let ((order-id (var-get next-order-id)))
    (map-set orders
      { order-id: order-id }
      {
        customer: tx-sender,
        supplier-id: supplier-id,
        total-amount: total-amount,
        status: "pending",
        created-date: block-height,
        delivery-date: none,
        payment-status: "unpaid"
      }
    )
    (var-set next-order-id (+ order-id u1))
    (ok order-id)
  )
)

;; Add item to order
(define-public (add-order-item
  (order-id uint)
  (item-index uint)
  (item-id uint)
  (quantity uint)
  (unit-price uint))
  (let ((subtotal (* quantity unit-price)))
    (match (map-get? orders { order-id: order-id })
      order-data
      (if (is-eq (get customer order-data) tx-sender)
        (begin
          (map-set order-items
            { order-id: order-id, item-index: item-index }
            {
              item-id: item-id,
              quantity: quantity,
              unit-price: unit-price,
              subtotal: subtotal
            }
          )
          (ok true)
        )
        (err u403)
      )
      (err u404)
    )
  )
)

;; Update order status
(define-public (update-order-status (order-id uint) (new-status (string-ascii 20)))
  (match (map-get? orders { order-id: order-id })
    order-data
    (if (or (is-eq tx-sender (get customer order-data))
            (is-eq tx-sender (var-get contract-owner)))
      (begin
        (map-set orders
          { order-id: order-id }
          (merge order-data { status: new-status })
        )
        (ok true)
      )
      (err u403)
    )
    (err u404)
  )
)

;; Process payment
(define-public (process-payment (order-id uint))
  (match (map-get? orders { order-id: order-id })
    order-data
    (if (is-eq (get customer order-data) tx-sender)
      (begin
        (map-set orders
          { order-id: order-id }
          (merge order-data { payment-status: "paid" })
        )
        (ok true)
      )
      (err u403)
    )
    (err u404)
  )
)

;; Get order details
(define-read-only (get-order (order-id uint))
  (map-get? orders { order-id: order-id })
)

;; Get order item
(define-read-only (get-order-item (order-id uint) (item-index uint))
  (map-get? order-items { order-id: order-id, item-index: item-index })
)

;; Check order status
(define-read-only (get-order-status (order-id uint))
  (match (map-get? orders { order-id: order-id })
    order-data (some (get status order-data))
    none
  )
)
