# n=5 model=out iset=I1 prefix14_class=262
cmp P2, P0
mov S2, P2
mov S0, P3
cmovge P2, P0
cmovg P0, S2
mov S2, P2
cmp P1, S0
cmovle P3, P1
cmovg S0, P1
cmp P3, P2
cmovl S2, P3
cmovle P3, P2
cmp P0, S0
cmovle P1, S0
