# n=5 model=out iset=I1 prefix14_class=9707
mov S0, P2
mov S1, P0
cmp P3, S0
cmovge S0, P3
cmovge P3, P2
cmp P1, P0
cmovge S1, P1
cmovge P1, P0
cmp S1, S0
cmovle P2, S0
cmovle S0, S1
cmovle S1, P2
cmp P1, P3
cmovl S1, P1
