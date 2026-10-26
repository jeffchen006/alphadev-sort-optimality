# n=5 model=out iset=I1 prefix14_class=7345
mov S0, P0
mov S2, P3
cmp P1, S0
cmovge P0, P1
cmovle S0, P1
cmp P2, S2
cmovle S2, P2
cmovl P2, P3
cmp S0, S2
cmovle P1, S0
cmovle S0, S2
cmovl S2, P1
mov S1, P2
cmp P2, P0
