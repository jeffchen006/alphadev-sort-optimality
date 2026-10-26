# n=5 model=out iset=I1 prefix14_class=7716
mov S2, P1
cmp P1, P3
cmovge P1, P3
cmovle S2, P3
cmp P0, P2
cmovge P3, P0
cmovl P3, P2
cmovg P0, P2
mov P2, P1
cmp P0, P2
cmovl P1, P0
mov P1, S2
cmovge P2, P0
mov P0, P2
