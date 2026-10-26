# n=5 model=out iset=I1 prefix14_class=7797
mov S2, P2
cmp S2, P0
cmovle P2, P0
cmovle P0, S2
mov S2, P1
cmp P1, P3
cmovle S2, P3
cmovge P1, P3
cmp P1, P0
cmovl S1, P0
cmovle P0, P1
cmovl P1, S1
mov S0, P2
cmp S2, S0
