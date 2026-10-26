# n=5 model=out iset=I1 prefix14_class=2188
mov S0, P0
mov S1, P1
cmp P1, P3
cmovle S1, P3
cmovg P1, P3
cmp S0, P2
cmovg S0, P2
cmovg P2, P0
cmp P2, S1
cmovle S2, P2
cmovl P2, S1
cmovle S1, S2
mov P0, S0
mov P3, S1
