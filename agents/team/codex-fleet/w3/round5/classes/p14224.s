# n=5 model=out iset=I1 prefix14_class=14224
mov S2, P0
cmp P1, P0
cmovle P0, P1
cmovle P1, S2
cmp P3, P2
mov S0, P1
cmovge S1, P2
cmovge P2, P3
cmovg P3, S1
cmp P2, S0
cmovle S0, P2
cmovge P1, P2
cmp P3, P0
cmovl S1, P0
