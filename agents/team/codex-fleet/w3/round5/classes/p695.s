# n=5 model=out iset=I1 prefix14_class=695
cmp P2, P1
mov S0, P1
cmovle S0, P2
cmovle P2, P1
mov P1, P0
mov S1, P2
cmp P1, P3
cmovle P0, P3
cmovg P1, P3
cmp P2, P0
cmovl S1, P0
cmovle P0, P2
cmp P1, S0
mov P2, P1
