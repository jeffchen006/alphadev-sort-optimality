# n=5 model=out iset=I1 prefix14_class=9116
cmp P0, P1
mov S0, P0
cmovg S0, P1
cmovl P0, P1
cmp P2, P3
mov P1, S0
cmovge S2, P2
cmovge P2, P3
cmovge P3, S2
cmp P2, S0
cmovle S0, P2
cmovg P1, P2
cmp P0, P3
cmovge S2, P0
