# n=5 model=out iset=I1 prefix14_class=9132
mov S0, P2
cmp P2, P3
cmovl P2, P3
cmovg S0, P3
cmp P1, P0
cmovge S1, P1
mov P3, S0
cmovg P1, P0
cmovge P0, S1
mov S2, P2
cmp P1, S0
cmovle S0, P1
cmovl P1, P3
mov S0, P1
