;; Inventory Tracking Contract
;; Tracks cleaning supply inventory across the supply chain

(define-map inventory-items
  { item-id: uint }
  {
    name: (string-ascii 100),
    category: (string-ascii 50),
    supplier-id: uint,
    quantity: uint,
    unit-price: uint,
    location: (string-ascii 100),
    last-updated: uint
  }
)

(define-map item-movements
  { movement-id: uint }
  {
    item-id: uint,
    from-location: (string-ascii 100),
    to-location: (string-ascii 100),
    quantity: uint,
    movement-type: (string-ascii 20),
    timestamp: uint,
    recorded-by: principal
  }
)

(define-data-var next-item-id uint u1)
(define-data-var next-movement-id uint u1)
(define-data-var contract-owner principal tx-sender)

;; Add new inventory item
(define-public (add-inventory-item
  (name (string-ascii 100))
  (category (string-ascii 50))
  (supplier-id uint)
  (quantity uint)
  (unit-price uint)
  (location (string-ascii 100)))
  (let ((item-id (var-get next-item-id)))
    (map-set inventory-items
      { item-id: item-id }
      {
        name: name,
        category: category,
        supplier-id: supplier-id,
        quantity: quantity,
        unit-price: unit-price,
        location: location,
        last-updated: block-height
      }
    )
    (var-set next-item-id (+ item-id u1))
    (ok item-id)
  )
)

;; Update inventory quantity
(define-public (update-inventory (item-id uint) (new-quantity uint))
  (match (map-get? inventory-items { item-id: item-id })
    item-data
    (begin
      (map-set inventory-items
        { item-id: item-id }
        (merge item-data { quantity: new-quantity, last-updated: block-height })
      )
      (ok true)
    )
    (err u404)
  )
)

;; Record item movement
(define-public (record-movement
  (item-id uint)
  (from-location (string-ascii 100))
  (to-location (string-ascii 100))
  (quantity uint)
  (movement-type (string-ascii 20)))
  (let ((movement-id (var-get next-movement-id)))
    (map-set item-movements
      { movement-id: movement-id }
      {
        item-id: item-id,
        from-location: from-location,
        to-location: to-location,
        quantity: quantity,
        movement-type: movement-type,
        timestamp: block-height,
        recorded-by: tx-sender
      }
    )
    (var-set next-movement-id (+ movement-id u1))
    (ok movement-id)
  )
)

;; Get inventory item
(define-read-only (get-inventory-item (item-id uint))
  (map-get? inventory-items { item-id: item-id })
)

;; Get item movement
(define-read-only (get-movement (movement-id uint))
  (map-get? item-movements { movement-id: movement-id })
)

;; Check stock level
(define-read-only (get-stock-level (item-id uint))
  (match (map-get? inventory-items { item-id: item-id })
    item-data (some (get quantity item-data))
    none
  )
)
