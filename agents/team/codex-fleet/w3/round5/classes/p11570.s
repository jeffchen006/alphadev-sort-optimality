# n=5 model=out iset=I1 prefix14_class=11570
mov S0, P3
cmp S0, P0
cmovle S0, P0
cmovge P3, P0
cmp P2, P1
cmovge P0, P1
mov S2, P3
cmovle P0, P2
cmovl P2, P1
cmp P0, P3
cmovl S2, P0
cmovle P0, P3
cmp S0, P2
cmovle P1, S0
