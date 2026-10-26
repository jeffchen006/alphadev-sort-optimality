# n=5 model=out iset=I1 prefix14_class=13558
cmp P1, P3
cmovle S0, P1
cmovle P1, P3
cmovge S0, P3
cmp P2, P0
cmovle P3, P0
cmovl P0, P2
cmovle P2, P3
cmp P0, S0
cmovle S1, S0
cmovg S1, P0
cmovge P0, S0
cmp P1, P2
cmovge P3, P2
