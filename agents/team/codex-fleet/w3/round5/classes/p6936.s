# n=5 model=out iset=I1 prefix14_class=6936
cmp P0, P1
cmovge S0, P0
cmovg P0, P1
cmovle S0, P1
cmp P3, P2
cmovl P1, P2
cmovl P2, P3
cmovge P1, P3
cmp S0, P1
cmovle P3, P1
cmovle P1, S0
cmovle S0, P3
cmp P0, P2
cmovle S1, P2
