# n=5 model=out iset=I1 prefix14_class=6903
mov S0, P0
cmp P1, S0
cmovle S0, P1
cmovg P0, P1
cmp P3, P2
cmovge P1, P3
cmovl P1, P2
cmovge P3, P2
cmp P0, P1
cmovle S1, P1
cmovle P1, P0
cmovg S1, P0
cmp P3, S0
cmovle S1, S0
