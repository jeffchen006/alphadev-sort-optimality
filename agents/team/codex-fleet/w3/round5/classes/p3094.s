# n=5 model=out iset=I1 prefix14_class=3094
cmp P2, P3
mov S1, P2
mov S0, P0
cmovg P2, P3
cmovle S1, P3
cmp P1, P0
cmovl S0, P1
mov S2, P2
cmovle P1, P0
cmp P2, S0
cmovl S2, S0
cmovge P2, S0
mov P2, S1
mov P3, S2
