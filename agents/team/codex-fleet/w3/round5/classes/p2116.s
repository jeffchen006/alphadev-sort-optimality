# n=5 model=out iset=I1 prefix14_class=2116
cmp P2, P1
mov S1, P3
cmovge S2, P1
cmovge P1, P2
cmovle S2, P2
cmp P3, P0
cmovl P3, P0
cmovg S1, P0
mov P2, S1
mov P0, P3
cmp P1, P3
cmovge P0, P1
cmovg P1, P3
mov S0, P1
