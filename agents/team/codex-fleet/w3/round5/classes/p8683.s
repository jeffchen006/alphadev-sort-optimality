# n=5 model=out iset=I1 prefix14_class=8683
mov S1, P2
mov S0, P1
cmp P1, P0
cmovl P1, P0
cmovg S0, P0
cmp P3, S1
cmovle S1, P3
cmovl P3, P2
mov P2, P3
cmp P1, P3
cmovle P2, P1
cmovge P3, P1
cmp S0, S1
cmovl P0, S1
