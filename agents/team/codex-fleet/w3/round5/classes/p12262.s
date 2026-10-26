# n=5 model=out iset=I1 prefix14_class=12262
cmp P0, P1
mov S0, P1
cmovg P1, P0
cmovle S0, P0
cmp P3, P2
cmovge P0, P2
cmovg P2, P3
mov S1, S0
cmovge P3, P0
cmp S0, P3
cmovle S0, P3
cmovg S1, P3
mov P3, S0
mov S1, P2
