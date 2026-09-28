; "Yusuke Misawa" on a black background.
; iNES header matches go-nes-by-pstack testdata/nestest.nes:
;   NES\x1A, PRG=1 (16KB), CHR=1 (8KB), flags6=0, flags7=0, rest zero.
; Mapper 0 (NROM-128). Horizontal mirroring. No trainer.

.segment "HEADER"
.byte "NES", $1A
.byte $01
.byte $01
.byte $00
.byte $00
.byte $00, $00, $00, $00, $00, $00, $00, $00

PPUCTRL   = $2000
PPUMASK   = $2001
PPUSTATUS = $2002
PPUSCROLL = $2005
PPUADDR   = $2006
PPUDATA   = $2007

.segment "CODE"

.proc reset
    sei
    cld
    ldx #$ff
    txs
    inx
    stx PPUCTRL
    stx PPUMASK
    stx $4010
    lda #$40
    sta $4017

    bit PPUSTATUS
@wait1:
    bit PPUSTATUS
    bpl @wait1
@wait2:
    bit PPUSTATUS
    bpl @wait2

    ; Palette 0: backdrop $0F (black), colors $30 (white).
    lda #$3f
    sta PPUADDR
    lda #$00
    sta PPUADDR
    lda #$0f
    sta PPUDATA
    lda #$30
    sta PPUDATA
    lda #$30
    sta PPUDATA
    lda #$30
    sta PPUDATA

    ; Nametable $2000 and its attribute table, all empty (tile 0, palette 0).
    lda #$20
    sta PPUADDR
    lda #$00
    sta PPUADDR
    lda #$00
    ldy #$04
    ldx #$00
@clear:
    sta PPUDATA
    inx
    bne @clear
    dey
    bne @clear

    ; One row, centered: row 14, column 9 → $21C9.
    lda #$21
    sta PPUADDR
    lda #$c9
    sta PPUADDR
    ldx #$00
@text:
    lda message, x
    sta PPUDATA
    inx
    cpx #13
    bne @text

    lda #$00
    sta PPUCTRL
    sta PPUSCROLL
    sta PPUSCROLL
    lda #$0a
    sta PPUMASK

@forever:
    jmp @forever
.endproc

.proc nmi
    rti
.endproc

.proc irq
    rti
.endproc

; Tile ids: Y u s u k e [space] M i s a w a
message:
    .byte 1, 2, 3, 2, 4, 5, 0, 6, 7, 3, 8, 9, 8

.segment "VECTORS"
.word nmi
.word reset
.word irq

.segment "CHARS"
.res 16, $00

; Y
.byte $c6, $66, $3c, $18, $18, $18, $18, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00
; u
.byte $00, $66, $66, $66, $66, $66, $3c, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00
; s
.byte $00, $3c, $66, $30, $0c, $66, $3c, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00
; k
.byte $60, $66, $6c, $78, $6c, $66, $66, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00
; e
.byte $00, $3c, $66, $7e, $60, $66, $3c, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00
; M
.byte $c3, $e7, $db, $db, $c3, $c3, $c3, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00
; i
.byte $18, $00, $18, $18, $18, $18, $18, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00
; a
.byte $00, $3c, $06, $3e, $66, $66, $3e, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00
; w
.byte $00, $c3, $c3, $c3, $db, $66, $24, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00

.res 8032, $00
