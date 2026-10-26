# n=5 model=out iset=I1 prefix14_class=9704
mov S2, P0
cmp P3, P1
mov S0, P3
cmovl S0, P1
cmovge P3, P1
cmp P2, S2
cmovge P0, P2
cmovg P2, S2
cmp P0, S0
cmovle S2, S0
cmovle S0, P0
mov P1, P3
cmovl P0, S2
cmp P1, P2
