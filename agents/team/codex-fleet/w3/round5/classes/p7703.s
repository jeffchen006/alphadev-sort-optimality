# n=5 model=out iset=I1 prefix14_class=7703
mov S0, P3
cmp P2, P1
mov S1, P1
cmovge S1, P2
cmovle P1, P2
cmp P0, S0
cmovg P3, P0
cmovl S0, P0
mov P0, P1
cmp P1, S0
cmovge P0, S0
cmovle P1, S0
cmp P3, S1
cmovle S0, P3
