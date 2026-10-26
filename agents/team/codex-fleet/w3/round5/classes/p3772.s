# n=5 model=out iset=I1 prefix14_class=3772
mov S1, P1
cmp P2, S1
cmovle S1, P2
cmovge P1, P2
mov P2, P0
cmp P3, P0
mov S0, S1
cmovge P0, P3
cmovg P3, P2
cmp S0, P3
cmovl S1, P3
cmovle P3, S0
cmp P0, P1
cmovle P3, P1
