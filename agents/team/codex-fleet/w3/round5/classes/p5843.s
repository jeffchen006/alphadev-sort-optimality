# n=5 model=out iset=I1 prefix14_class=5843
mov S0, P2
cmp S0, P1
cmovge P2, P1
cmovle S0, P1
cmp P3, P0
cmovl P1, P3
cmovl P3, P0
cmovl P0, P1
mov S1, P0
mov S2, S0
cmp S1, P2
cmovle S1, P2
cmovle P2, P0
cmp S0, P3
