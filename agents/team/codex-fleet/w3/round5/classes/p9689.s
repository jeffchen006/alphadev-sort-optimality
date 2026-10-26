# n=5 model=out iset=I1 prefix14_class=9689
cmp P3, P1
cmovg S0, P1
cmovge P1, P3
cmovle S0, P3
cmp P0, P2
cmovge S1, P2
cmovle S1, P0
cmovl P0, P2
cmp P0, P1
cmovg S2, P0
cmovge P0, P1
cmovle S2, P1
cmp S1, S0
cmovle P3, S0
