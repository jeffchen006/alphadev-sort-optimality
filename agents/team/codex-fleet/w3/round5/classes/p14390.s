# n=5 model=out iset=I1 prefix14_class=14390
cmp P0, P3
cmovle S2, P3
cmovl P3, P0
cmovge S2, P0
cmp P2, P1
cmovle S0, P2
cmovg S0, P1
cmovle P2, P1
cmp S0, P3
cmovge P1, S0
cmovge S0, P3
cmovg P3, P1
cmp P2, S2
cmovg P0, P2
