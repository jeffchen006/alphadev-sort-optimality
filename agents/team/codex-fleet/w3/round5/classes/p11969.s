# n=5 model=out iset=I1 prefix14_class=11969
mov S0, P2
cmp P0, S0
mov S1, P3
cmovg P2, P0
cmovle S0, P0
cmp P1, S1
cmovle P3, P1
cmovl P1, S1
cmovg S1, P1
cmp P3, S0
cmovge P0, S0
cmovge S0, P3
cmovge P3, P0
cmp P1, P2
