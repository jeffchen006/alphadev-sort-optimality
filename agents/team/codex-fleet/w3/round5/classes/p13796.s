# n=5 model=out iset=I1 prefix14_class=13796
cmp P3, P1
cmovge S2, P3
cmovg P3, P1
cmovg P1, S2
mov S0, P2
cmp P2, P0
cmovg S0, P0
mov S1, P1
cmovl P2, P0
cmp P2, S1
cmovle S1, P2
cmovge P1, P2
mov P1, P3
cmp P1, S0
