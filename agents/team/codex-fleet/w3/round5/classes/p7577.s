# n=5 model=out iset=I1 prefix14_class=7577
mov S1, P3
cmp P2, P0
cmovle S0, P2
cmovg S0, P0
cmovge P0, P2
cmp S1, P1
cmovl P3, P1
cmovg S1, P1
cmp S1, S0
mov P2, P3
cmovle P1, S1
cmovle S1, S0
cmovl S0, P1
cmp P2, P0
