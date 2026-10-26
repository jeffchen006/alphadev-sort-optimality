# n=5 model=out iset=I1 prefix14_class=10462
cmp P2, P1
mov S1, P3
mov S0, P2
cmovle P2, P1
cmovle P1, S0
cmp P0, S1
cmovl S1, P0
cmovle P0, P3
mov P3, P2
cmp P3, P0
cmovle P2, P0
cmovle P0, P3
cmp P1, S1
cmovge P3, S1
