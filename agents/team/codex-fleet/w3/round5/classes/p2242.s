# n=5 model=out iset=I1 prefix14_class=2242
mov S0, P1
cmp P2, S0
cmovg S0, P2
cmovg P2, P1
mov S1, P3
cmp P0, P3
cmovge S1, P0
cmovge P0, P3
mov P1, S1
cmp P1, S0
cmovle S1, S0
cmovle S0, P1
cmp P0, P2
cmovle S1, P0
