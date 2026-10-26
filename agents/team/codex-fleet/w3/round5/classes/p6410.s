# n=5 model=out iset=I1 prefix14_class=6410
cmp P1, P3
cmovg S0, P1
cmovg P1, P3
cmovg P3, S0
mov S1, P2
cmp P0, P2
cmovge S1, P0
cmovle P2, P0
cmp P3, S1
cmovle P0, S1
cmovg P0, P3
cmovle S1, P3
cmp P2, P1
mov P3, S1
