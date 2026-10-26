# n=5 model=out iset=I1 prefix14_class=6310
cmp P3, P1
cmovg S2, P1
cmovge P1, P3
cmovle S2, P3
mov P3, P0
cmp P2, P3
cmovl P0, P2
cmovge P3, P2
cmp P3, P1
mov S1, P1
cmovg P1, P3
cmovg P3, S1
cmp P0, S2
cmovg S0, S2
