;; TokenForge - Enhanced Trading Contract
;; A comprehensive token trading platform with advanced features

;; ============================================================
;; CONSTANTS & ERRORS
;; ============================================================
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_INSUFFICIENT_BALANCE (err u1))
(define-constant ERR_INVALID_AMOUNT (err u2))
(define-constant ERR_UNAUTHORIZED (err u3))
(define-constant ERR_TRADING_PAUSED (err u4))
(define-constant ERR_TRANSFER_FAILED (err u5))
(define-constant ERR_INVALID_RECIPIENT (err u6))
(define-constant ERR_PRICE_TOO_LOW (err u7))

;; ============================================================
;; DATA VARIABLES
;; ============================================================
(define-data-var total-supply uint u0)
(define-data-var trading-paused bool false)
(define-data-var token-price uint u100) ;; Price per token in microSTX
(define-data-var minimum-trade uint u1) ;; Minimum trade amount
(define-data-var maximum-trade uint u1000000) ;; Maximum trade amount
(define-data-var total-transactions uint u0)

;; ============================================================
;; DATA MAPS
;; ============================================================

;; Store user balances
(define-map balances 
    principal 
    uint
)

;; Track user transaction history count
(define-map user-transaction-count
    principal
    uint
)

;; Store transaction details
(define-map transactions
    uint ;; transaction-id
    {
        user: principal,
        action: (string-ascii 10),
        amount: uint,
        timestamp: uint,
        price: uint
    }
)

;; Allowances for transfers (like ERC20 approve/transferFrom)
(define-map allowances
    {owner: principal, spender: principal}
    uint
)

;; Track locked tokens (for future staking/vesting features)
(define-map locked-balances
    principal
    {
        amount: uint,
        unlock-height: uint
    }
)

;; Whitelist for special privileges
(define-map whitelist
    principal
    bool
)

;; ============================================================
;; PRIVATE FUNCTIONS
;; ============================================================

(define-private (record-transaction (action (string-ascii 10)) (amount uint))
    (let (
          (tx-id (var-get total-transactions))
          (sender tx-sender)
          (current-count (default-to u0 (map-get? user-transaction-count sender)))
         )
        (begin
            ;; Store transaction details
            (map-set transactions tx-id {
                user: sender,
                action: action,
                amount: amount,
                timestamp: block-height,
                price: (var-get token-price)
            })
            
            ;; Update user transaction count
            (map-set user-transaction-count sender (+ current-count u1))
            
            ;; Increment total transactions
            (var-set total-transactions (+ tx-id u1))
            
            tx-id
        )
    )
)

;; ============================================================
;; PUBLIC FUNCTIONS - TRADING
;; ============================================================

;; Buy tokens with enhanced validation
(define-public (buy (amount uint))
    (let (
          (sender tx-sender)
          (current-balance (default-to u0 (map-get? balances sender)))
          (min-trade (var-get minimum-trade))
          (max-trade (var-get maximum-trade))
         )
        (begin
            ;; Validations
            (asserts! (not (var-get trading-paused)) ERR_TRADING_PAUSED)
            (asserts! (> amount u0) ERR_INVALID_AMOUNT)
            (asserts! (>= amount min-trade) ERR_INVALID_AMOUNT)
            (asserts! (<= amount max-trade) ERR_INVALID_AMOUNT)
            
            ;; Update user balance
            (map-set balances sender (+ current-balance amount))
            
            ;; Update total supply
            (var-set total-supply (+ (var-get total-supply) amount))
            
            ;; Record transaction
            (record-transaction "buy" amount)
            
            (ok { 
                action: "buy", 
                amount: amount, 
                new-balance: (+ current-balance amount),
                price: (var-get token-price)
            })
        )
    )
)

;; Sell tokens with enhanced validation
(define-public (sell (amount uint))
    (let (
          (sender tx-sender)
          (current-balance (default-to u0 (map-get? balances sender)))
          (min-trade (var-get minimum-trade))
         )
        (begin
            ;; Validations
            (asserts! (not (var-get trading-paused)) ERR_TRADING_PAUSED)
            (asserts! (> amount u0) ERR_INVALID_AMOUNT)
            (asserts! (>= amount min-trade) ERR_INVALID_AMOUNT)
            (asserts! (>= current-balance amount) ERR_INSUFFICIENT_BALANCE)
            
            ;; Update user balance
            (map-set balances sender (- current-balance amount))
            
            ;; Update total supply
            (var-set total-supply (- (var-get total-supply) amount))
            
            ;; Record transaction
            (record-transaction "sell" amount)
            
            (ok { 
                action: "sell", 
                amount: amount, 
                new-balance: (- current-balance amount),
                price: (var-get token-price)
            })
        )
    )
)

;; ============================================================
;; PUBLIC FUNCTIONS - TRANSFERS
;; ============================================================

;; Transfer tokens to another user
(define-public (transfer (amount uint) (recipient principal))
    (let (
          (sender tx-sender)
          (sender-balance (default-to u0 (map-get? balances sender)))
          (recipient-balance (default-to u0 (map-get? balances recipient)))
         )
        (begin
            ;; Validations
            (asserts! (not (is-eq sender recipient)) ERR_INVALID_RECIPIENT)
            (asserts! (> amount u0) ERR_INVALID_AMOUNT)
            (asserts! (>= sender-balance amount) ERR_INSUFFICIENT_BALANCE)
            
            ;; Update balances
            (map-set balances sender (- sender-balance amount))
            (map-set balances recipient (+ recipient-balance amount))
            
            ;; Record transaction
            (record-transaction "transfer" amount)
            
            (ok { 
                action: "transfer",
                from: sender,
                to: recipient,
                amount: amount
            })
        )
    )
)