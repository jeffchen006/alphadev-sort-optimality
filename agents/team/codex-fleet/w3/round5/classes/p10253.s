# n=5 model=out iset=I1 prefix14_class=10253
mov S1, P1
cmp S1, P3
cmovge P1, P3
mov S0, P2
cmovl S1, P3
cmp S0, P0
cmovg S0, P0
cmovl P2, P0
cmp S1, P2
cmovle S2, S1
cmovle S1, P2
cmovl P2, S2
cmp S0, P1
mov P0, P1
