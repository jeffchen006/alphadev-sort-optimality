# n=5 model=out iset=I1 prefix14_class=13346
mov S0, P2
cmp S0, P0
cmovg P2, P0
cmovle S0, P0
cmp P3, P1
cmovle P0, P3
cmovle P3, P1
cmovle P1, P0
cmp P2, P1
mov S2, P1
cmovge P1, P2
cmovl S2, P2
mov S2, S0
mov P2, P1
