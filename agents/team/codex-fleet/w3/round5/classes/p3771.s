# n=5 model=out iset=I1 prefix14_class=3771
mov S1, P1
cmp P2, S1
cmovle S1, P2
cmovge P1, P2
mov P2, P3
cmp P0, P3
mov S0, S1
cmovge P3, P0
cmovg P0, P2
cmp S1, P0
cmovl S1, P0
cmovle P0, S0
cmp P3, P1
cmovle P0, P1
