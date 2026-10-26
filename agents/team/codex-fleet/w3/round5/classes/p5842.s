# n=5 model=out iset=I1 prefix14_class=5842
mov S1, P3
cmp S1, P2
cmovge P3, P2
cmovl S1, P2
cmp P1, P0
cmovl P2, P1
cmovl P1, P0
cmovl P0, P2
mov S2, S1
mov S0, P0
cmp S0, P3
cmovle S0, P3
cmovle P3, P0
cmp S2, P1
